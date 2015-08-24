package cn.bcia.bigdata.iop.eval;

import java.sql.SQLException;

public class MainEvaluator {
	public static void main(String[] args) throws ClassNotFoundException, SQLException {
		Evaluator bigsql = new BigSQLEvaluator();
		bigsql.evaluate();
		
		Evaluator hdfs = new HdfsEvaluator();
		hdfs.evaluate();
	}
}
