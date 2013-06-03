
package guilinsoft.sky.action;

import guilinsoft.sky.client.MRecordClient;
import guilinsoft.sky.utils.MMsg;

import java.util.List;

import com.jzero.core.MR;
import com.jzero.core.MURI;
import com.jzero.db.core.M;
import com.jzero.render.MB;
import com.jzero.util.MCheck;
import com.jzero.util.MCnt;
import com.jzero.util.MDate;
import com.jzero.util.MEnum;
import com.jzero.util.MPro;
import com.jzero.util.MRecord;
import com.jzero.util.MTool;

/** 
 * 2012-11-14:首台页面操作
 * wangujqw@gmail.com
 */
public class Index {
	private static boolean bool_client_connect=false;
	//开启服务监听
	class ClientConnect extends Thread {
		@Override
		public void run() {
			MRecordClient.me().start();//开启连接服务器
		}
	}	
	//首页
	public void index(){
		MRecord out=get_comm();
		
		//推荐商品(默认前几个进行滚动)
		out.set("recommendLst", M.me().get_pager_c(MMsg.WZ_CONTENT, MCnt.me().and("endtime", MEnum.GT_E, MDate.get_ymd()).toStr(),"recommended",10,new Object[]{"ORDER BY is_recommend DESC"}));
		
		//推荐广告
		out.set("adLst", M.me().get_pager_c(MMsg.WZ_ADVERTISING, MCnt.me().and("endtime", MEnum.GT_E, MDate.get_ymd()).toStr(),"aded",new Object[]{"ORDER BY is_recommend DESC"}));
		
		//首页图片
		out.set("picLst", M.me().get_pager_c(MMsg.WZ_ADVERTISING, MCnt.me().and("endtime", MEnum.GT_E, MDate.get_ymd()).and_eq("is_home_pic","1").toStr(), "piced", new Object[]{"order by pubdate desc"}));
		
		out.set("page", "index_first");//默认第一个选中
		MR.me().setAttr(MMsg.OBJECT, out);
		if(!bool_client_connect){
			new ClientConnect().start();  
			bool_client_connect=true;
		}
		MB.me().getJspRender("/index.jsp");
	}
	
	private MRecord get_comm(){
		MRecord out=new MRecord();
		//一级分类菜单表
		out.set("categoryLst",M.me().get_where(MMsg.XT_CATEGORY, MCnt.me().first_eq("parent_id", 0).toStr(), new Object[]{"order by sort asc"}));
		//公告信息
		out.set("noticeContent", MTool.read(MMsg.TXT_NOTICE));
		return out;
	}

	//子菜单
	public void submenu(){
		String main_id=MTool.decode(MURI.me().seg_str(2));//主菜单ID
		//二级菜单
		List<MRecord> submenuLst=M.me().get_where(MMsg.XT_CATEGORY, MCnt.me().first_eq("parent_id", main_id).toStr(),new Object[]{" order by sort asc"} );
		List<MRecord> contentLst=null;
		//取默认第一个一级菜单的列表
		if(!MCheck.isNull(submenuLst)){
			MRecord category=submenuLst.get(0);
			String where=MCnt.me().first_eq("parent_id", main_id).and_eq("category_id", category.get("id")).and_eq("is_audit",1).and("endtime", MEnum.GT_E,MDate.get_ymd()).toStr();
			contentLst=M.me().get_where(MMsg.WZ_CONTENT, where, "order by pubdate desc");
		}
		
		//推荐商品
		List<MRecord> recommendLst=M.me().get_pager_c(MMsg.WZ_CONTENT, MCnt.me().and_eq("is_audit", 1).and_eq("is_recommend", 1).and_eq("parent_id", main_id).and("endtime", MEnum.GT_E, MDate.get_ymd()).toStr(),"recommended",10,new Object[]{"order by pubdate DESC"});
		
		MRecord out=get_comm();
		out.set("submenuLst", submenuLst).set("contentLst", contentLst).set("recommendLst", recommendLst);
		out.set("page", "index_"+main_id);//导航选中状态
		MR.me().setAttr(MMsg.OBJECT, out);
		MB.me().getJspRender("/submenu.jsp");
	}
	//子内容列表
	public void subcontent(){
		String parent_id=MURI.me().seg_str(2);
		String main_id=MURI.me().seg_str(3);
		
		//二级菜单
		List<MRecord> submenuLst=M.me().get_where(MMsg.XT_CATEGORY, MCnt.me().first_eq("parent_id", main_id).toStr(),new Object[]{" order by sort asc"} );
		String where=MCnt.me().first_eq("parent_id", main_id).and_eq("category_id", parent_id).and_eq("is_audit",1).and("endtime", MEnum.GT_E,MDate.get_ymd()).toStr();
		List<MRecord> contentLst=M.me().get_where(MMsg.WZ_CONTENT, where, "order by pubdate desc");
		
		//推荐商品
		List<MRecord> recommendLst=M.me().get_pager_c(MMsg.WZ_CONTENT, MCnt.me().and_eq("is_audit", 1).and_eq("is_recommend", 1).and_eq("parent_id", main_id).and("endtime", MEnum.GT_E, MDate.get_ymd()).toStr(),"recommended",10,new Object[]{"order by pubdate DESC"});
		
		MRecord out=get_comm();
		out.set("submenuLst", submenuLst).set("contentLst", contentLst).set("recommendLst", recommendLst);
		out.set("page", "index_"+main_id);//导航选中状态
		MR.me().setAttr(MMsg.OBJECT, out);
		MB.me().getJspRender("/submenu.jsp");		
	}
	//是看广告
	public void ad(){
		String content_id=MURI.me().seg_str(2);
		String main_id=MURI.me().seg_str(3);
		//二级菜单
		List<MRecord> submenuLst=M.me().get_where(MMsg.XT_CATEGORY, MCnt.me().first_eq("parent_id", main_id).toStr(),new Object[]{" order by sort asc"} );
		MRecord contentObj=M.me().one_t(MMsg.WZ_ADVERTISING, MCnt.me().and_eq("id", content_id).toStr());
		MRecord out=get_comm();
		out.set("submenuLst", submenuLst).set("contentObj", contentObj);
		out.set("page", "index_"+main_id);//导航选中状态
		MR.me().setAttr(MMsg.OBJECT, out);
		MB.me().getJspRender("/ad.jsp");
	}	
	
	//实体内容
	public void content(){
		String content_id=MURI.me().seg_str(2);
		String main_id=MURI.me().seg_str(3);
		//二级菜单
		List<MRecord> submenuLst=M.me().get_where(MMsg.XT_CATEGORY, MCnt.me().first_eq("parent_id", main_id).toStr(),new Object[]{" order by sort asc"} );
		
		MRecord contentObj=M.me().one_t(MMsg.WZ_CONTENT, MCnt.me().and_eq("id", content_id).toStr());
		
		//明细图片
		List<MRecord> subImg=M.me().get_where(MMsg.WZ_CONTENT_MX, MCnt.me().first_eq("pid", content_id).toStr());
		MRecord out=get_comm();
		out.set("submenuLst", submenuLst).set("contentObj", contentObj).set("subImg", subImg);
		out.set("page", "index_"+main_id);//导航选中状态
		MR.me().setAttr(MMsg.OBJECT, out);
		MB.me().getJspRender("/content.jsp");
	}
	
	//联系我们
	public void contact(){
		String contact= MTool.read(MMsg.TXT_CONTACT);
		MRecord out=get_comm();
		out.set("contact", contact);
		out.set("page", "index_last");//导航选中状态
		MR.me().setAttr(MMsg.OBJECT, out);
		MB.me().getJspRender("/contact.jsp");
	}
	
	//购买
	public void buy(){
		String content_id=MURI.me().seg_str(2);
		String main_id=MURI.me().seg_str(3);
		//二级菜单
		List<MRecord> submenuLst=M.me().get_where(MMsg.XT_CATEGORY, MCnt.me().first_eq("parent_id", main_id).toStr(),new Object[]{" order by sort asc"} );
		
		MRecord contentObj=M.me().one_t(MMsg.WZ_CONTENT, MCnt.me().and_eq("id", content_id).toStr());
		
		MRecord out=get_comm();
		out.set("submenuLst", submenuLst).set("contentObj", contentObj);
		out.set("page", "index_"+main_id);//导航选中状态
		MR.me().setAttr(MMsg.OBJECT, out);
		MB.me().getJspRender("/buy.jsp");		
	}
	
	
	//参数设置操作
	public void set(){
		MRecord out=get_comm();
		MR.me().setAttr(MMsg.OBJECT, out);
		MB.me().getJspRender("/set.jsp");		
	}
	//保存设置的值
	public void save_set(){
		String read_all=MR.me().getPara("read_all");//是否同步所有数据
		String target_url=MR.me().getPara("target_url");//远程下载地址
		String target_ip=MR.me().getPara("target_ip");//远程服务器IP
		String target_port=MR.me().getPara("target_port");//远程服务器端口
		String wait_time=MR.me().getPara("wait_time");//等待时间
		String serno=MR.me().getPara("serno");	//终端编号
		String read_category=MR.me().getPara("read_category");//是否读取菜单
		String read_contact=MR.me().getPara("read_contact");//是否读取联系我们
		String read_notice=MR.me().getPara("read_notice");//是否读取公告信息
		String lastsyn	=MR.me().getPara("lastsyn");//是后更新时间
		MPro me=MPro.me();
		me.setValue("read_all", read_all);
		me.setValue("target_url", target_url);
		me.setValue("target_ip", target_ip);
		me.setValue("target_port", target_port);
		me.setValue("wait_time", wait_time);
		me.setValue("serno", serno);
		me.setValue("read_category", read_category);
		me.setValue("read_contact", read_contact);
		me.setValue("read_notice", read_notice);
		me.setValue("lastsyn", lastsyn);
		MRecord out=get_comm();
		out.set(MMsg.MESSAGE,MMsg.SAVE_SUCCESS);
		MR.me().setAttr(MMsg.OBJECT, out);
		MB.me().getJspRender("/set.jsp");	
	}
}
