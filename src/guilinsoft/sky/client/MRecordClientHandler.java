package guilinsoft.sky.client;

import guilinsoft.sky.utils.MMsg;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.ChannelInboundMessageHandlerAdapter;
import io.netty.util.HashedWheelTimer;
import io.netty.util.Timeout;
import io.netty.util.Timer;
import io.netty.util.TimerTask;

import java.util.List;
import java.util.concurrent.TimeUnit;

import com.jzero.db.cache.MFile;
import com.jzero.db.core.M;
import com.jzero.log.Log;
import com.jzero.upload.MDown;
import com.jzero.util.MCheck;
import com.jzero.util.MCnt;
import com.jzero.util.MDate;
import com.jzero.util.MPath;
import com.jzero.util.MPrint;
import com.jzero.util.MPro;
import com.jzero.util.MRecord;
import com.jzero.util.MTool;

public class MRecordClientHandler extends
		ChannelInboundMessageHandlerAdapter<MRecord> {
	private static String resource_url=MPro.me().getStr("target_url");
	@Override
	protected void messageReceived(ChannelHandlerContext ctx, MRecord msg)
			throws Exception {
		String commend=msg.getStr(MMsg.COMMEND);
		if(commend.equalsIgnoreCase("OK")){//已取到数据
			MPrint.print("已接收到数据"+msg);
			Log.me().write("已接收到数据");
			syn_tb_datas(msg);
			MPro.me().setValue("lastsyn", MDate.get_ymd());
		}else{
			MPrint.print(msg.get("MSG"));//出错原因
			Log.me().write(msg.getStr("MSG"));
		}
		
	}
	/**
	 * 进行更新操作
	 * @param msg
	 */
	private void syn_tb_datas(MRecord msg) {
		//1、广告
		List<MRecord> advertisingLst=msg.get(LST.ADVERTISING.name());
		insert_tb(advertisingLst,MMsg.WZ_ADVERTISING);
		//2、内容
		List<MRecord> contentLst=msg.get(LST.CONTENT.name());
		insert_tb(contentLst,MMsg.WZ_CONTENT);
		//3、内容明细
		List<MRecord> contentMxLst=msg.get(LST.CONTENTMX.name());
		insert_tb(contentMxLst,MMsg.WZ_CONTENT_MX);
		//4、目录
		List<MRecord> categoryLst=msg.get(LST.CATEGORY.name());
		insert_tb(categoryLst,MMsg.XT_CATEGORY);
		//5、联系我们
		String contact=msg.getStr(MMsg.CONTACT);
		if(!MCheck.isNull(contact)){
			MTool.write(MMsg.TXT_CONTACT,contact);
		}
		//6、公告信息
		String notice=msg.getStr(MMsg.NOTICE);
		if(!MCheck.isNull(notice)){
			MTool.write(MMsg.TXT_NOTICE,notice);
		}
		
	}
	private void insert_tb(List<MRecord> lst,String table){
		if(!MCheck.isNull(lst)){
			for(MRecord row:lst){
				if(!MCheck.isNull(row)){
					//先判断是否存在,因为IP是从服务器那边传过来的,所以在服务端为唯一
					String where=MCnt.me().and_eq("id", row.getStr("id")).toStr();
					boolean boolExist=M.me().check(table, where);
					if(!boolExist){//不存在插入
						M.me().insert(table, conver(row));//操作数据库
					}
				}
			}
		}
	}
	/**
	 * 负责将true转换成1:false转换成0
	 */
	private MRecord conver(MRecord in){
		final String is_audit="is_audit";
		final String is_recommend="is_recommend";
		final String is_home_pic="is_home_pic";
		
		String bool_audit=in.getStr(is_audit);
		String bool_recommend=in.getStr(is_recommend);
		String bool_homePic=in.getStr(is_home_pic);
		
		if(!MCheck.isNull(bool_audit)){
			in.set(is_audit, bool_audit.equalsIgnoreCase("true")?1:0);
		}
		if(!MCheck.isNull(bool_recommend)){
			in.set(is_recommend, bool_recommend.equalsIgnoreCase("true")?1:0);
		}
		if(!MCheck.isNull(bool_homePic)){
			in.set(is_home_pic, bool_homePic.equalsIgnoreCase("true")?1:0);
		}
		return in;
	}
 	private String getFileName(String path){
		return path.substring(path.lastIndexOf("/")+1); 
	}
 	private String getFilePath(String path){
 		return path.substring(0,path.lastIndexOf("/"));
 	}
	@Override
	protected void endMessageReceived(ChannelHandlerContext ctx)
			throws Exception {
		MPrint.print("启动下载远程图片线程");
		Log.me().write("启动下载远程图片线程");
		Thread thread=new downPicThread();//下载远程图片线程
		thread.start();
		
		// 先判断是否已更改成读取全部,如果是读取全部
		final ChannelHandlerContext cx = ctx;
		final Timer timer = new HashedWheelTimer();
		timer.newTimeout(new TimerTask() {
			public void run(Timeout timeout) throws Exception {
				MRecord send_datas = get_send_datas();
				cx.write(send_datas);
			}
		}, MPro.me().getInt("wait_time"), TimeUnit.MINUTES);
	}
	class downPicThread extends Thread{
		@Override
		public void run() {
			downPic();
		}
	}
	/**
	 * 在同步完成之后使用
	 * 开启一个线程进行图片下载(seccuess=0)的状态,下载失败则删除
	 */
	private void downPic(){
		//广告
		List<MRecord> advertisingLst=M.me().get_where(MMsg.WZ_ADVERTISING, MCnt.me().first_eq("success", 0).toStr());
		save_pic(advertisingLst,MMsg.WZ_ADVERTISING);
		//内容
		List<MRecord> contentLst=M.me().get_where(MMsg.WZ_CONTENT, MCnt.me().first_eq("success", 0).toStr());
		save_pic(contentLst,MMsg.WZ_CONTENT);
		//内容明细
		List<MRecord> contentMxLst=M.me().get_where(MMsg.WZ_CONTENT_MX, MCnt.me().first_eq("success", 0).toStr());
		save_pic(contentMxLst,MMsg.WZ_CONTENT_MX);
	}
	/**
	 * 同步完成之后操作,如果下载不了,则进行删除操作
	 */
	private void save_pic(List<MRecord> lst,String table){
		if(!MCheck.isNull(lst)){
			for(MRecord tempRe:lst){
				String path=tempRe.getStr("path");
				if(!MCheck.isNull(path)){
					String imgUrl    = resource_url+"/upload/"+path;	//服务器上的图片路径
					String filePath	 =getFilePath(path);				//图片保存的h目录
					String imagename =getFileName(imgUrl);								//图片名称
					String full_path=MFile.createFile(MPath.me().getWebRoot()+"upload/"+filePath,imagename).getPath();//创建目录与名称
					boolean isOK = false;
					try {
						isOK = MDown.saveUrlAs(imgUrl,full_path);
					} catch (Exception e) {
						MPrint.print(e.getMessage());
					}									//保存圖片
					if(isOK){
						M.me().update(table, new MRecord().set("success", 1), MCnt.me().first_eq("id", tempRe.getStr("id")).toStr());
					}
//					else{
						//如果没有取到图片,则不更新
//						M.me().delete(table,MCnt.me().first_eq("id", tempRe.getStr("id")).toStr());
//					}
					Log.me().write("是否下载成功..= "+isOK+" 下载文件路径 :"+imgUrl);
				}
//				else{//有些表没有图片操作,则直接删除
					//M.me().delete(table,MCnt.me().first_eq("id", tempRe.getStr("id")).toStr());
//				}
			}
		}
	}
	@Override
	public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause)
			throws Exception {
		MPrint.print("Client Hander Exception :" + cause.getLocalizedMessage());
		ctx.close();
	}

	@Override
	public void channelActive(ChannelHandlerContext ctx) throws Exception {
		MPrint.print("channelActive ");
		MRecord send_datas = get_send_datas();
		ctx.write(send_datas);
	}

	private MRecord get_send_datas() {
		MPro.me().load_file(MMsg.OTHER_CONFIG);
		//在这之前需不需要重新加载一次config.properties?
		boolean read_all = MPro.me().getBool("read_all");//是否同步所有数据
		String serno = MPro.me().getStr("serno");//终端号
		MRecord send_datas = new MRecord().set(MMsg.SERNO, serno);
		
		if (read_all) {
			send_datas.set(MMsg.COMMEND, MMsg.READ_ALL);
			MPro.me().setValue("read_all", "false");
		} else {
			boolean read_category=MPro.me().getBool("read_category");//是否需要更新目录表
			boolean read_contact=MPro.me().getBool("read_contact");//读取联系我们
			boolean read_notice=MPro.me().getBool("read_notice");//读取公告信息
			if(read_category){MPro.me().setValue("read_category", "false");}
			if(read_contact){MPro.me().setValue("read_contact", "false");}
			if(read_notice){MPro.me().setValue("read_notice", "false");}
			
			String update = MPro.me().getStr("lastsyn");//最后同步时间
			send_datas.set(MMsg.COMMEND, MMsg.READ).set(MMsg.UPDATETIME, update).set(MMsg.CATEGORY, read_category).set(MMsg.CONTACT, read_contact).set(MMsg.NOTICE,read_notice );
		}
		return send_datas;
	}
}
