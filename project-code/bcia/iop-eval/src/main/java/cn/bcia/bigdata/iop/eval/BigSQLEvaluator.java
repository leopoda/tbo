package cn.bcia.bigdata.iop.eval;

import java.sql.Statement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;

/**
 * BIGSQL Evaluator
 *
 */
public class BigSQLEvaluator implements Evaluator {
	public void evaluate() {
		Connection connection = null;
		try {
			Class.forName("com.ibm.db2.jcc.DB2Driver");
			connection = DriverManager.getConnection("jdbc:db2://bi02:51000/BIGSQL", "bigsql", "password");

			Statement statement = connection.createStatement();
			ResultSet resultSet = statement.executeQuery("select col1, col2 from test1");
			while (resultSet.next()) {
				String col1 = resultSet.getString("col1");
				String col2 = resultSet.getString("col2");
				System.out.println("col1:" + col1 + "\tcol2:" + col2);
			}
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
	}
}
