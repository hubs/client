package guilinsoft.sky.client;

import io.netty.bootstrap.Bootstrap;
import io.netty.channel.Channel;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.nio.NioSocketChannel;
import io.netty.handler.codec.serialization.ClassResolvers;
import io.netty.handler.codec.serialization.ObjectDecoder;
import io.netty.handler.codec.serialization.ObjectEncoder;

import java.net.InetSocketAddress;

import com.jzero.util.MCheck;
import com.jzero.util.MPrint;
import com.jzero.util.MPro;

public class MRecordClient {
	public static MRecordClient client=new MRecordClient();
	private static Bootstrap b=new Bootstrap();
	private MRecordClient(){}
	public static MRecordClient me(){
		return client;
	}
	public void start(){
		MPrint.print("已开启Client Hander 连接　");
		try{
			b.group(new NioEventLoopGroup())
			.channel(NioSocketChannel.class)
			.handler(new ChannelInitializer<Channel>() {
				@Override
				protected void initChannel(Channel ch) throws Exception {
					ch.pipeline().addLast(new ObjectEncoder(),
							new ObjectDecoder(ClassResolvers.cacheDisabled(null)),
							new MRecordClientHandler()
					);
				}
			});
			b.connect(new InetSocketAddress(MPro.me().getStr("target_ip"), MPro.me().getInt("target_port"))).sync().channel().closeFuture().sync();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}finally{
			b.shutdown();
		}
	}
	public void stop(){
		if(!MCheck.isNull(b)){
			b.shutdown();
		}
	}
	public void restart(){
		stop();
		start();
	}
}
