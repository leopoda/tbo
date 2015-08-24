package cn.bcia.bigdata.iop.eval;

import java.io.IOException;
import java.net.URI;

import org.apache.commons.compress.utils.IOUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;

public class HdfsEvaluator implements Evaluator {

	public void evaluate() {
	    urlCat("/rawdata/positions/860100010030100003/2015-06-07/2015-06-07.dat");
	}
	
	public void urlCat(String url) {
		Configuration conf = new Configuration();
		try {
			FileSystem fs = FileSystem.get(URI.create(url), conf);
			FSDataInputStream in = fs.open(new Path(url));
			in.seek(0);
			IOUtils.copy(in, System.out, 4096);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
