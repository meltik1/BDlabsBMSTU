package lab4;

import java.sql.*;
import oracle.jdbc.pool.OracleDataSource;

public class JDBCConnection
{
    public static OracleDataSource ods;
    public static Connection connection;

    static {
        try {
            ods = new OracleDataSource();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        String url = "jdbc:oracle:thin:@//localhost:1521/dblabs";
        ods.setURL(url);
        ods.setUser("meltik");
        ods.setPassword("300800");
        try {
            connection = ods.getConnection();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    /*
        Возвращает Имя компании по id
     */
    public static String get_ra_by_id(int id) throws SQLException {
        Statement statement = connection.createStatement();
        ResultSet set = statement.executeQuery("SELECT AGENCY_NAME FROM" +
                " REALTY_AGENCIES WHERE RA_ID = " + id);

        ResultSetMetaData metaData = set.getMetaData();

        Object[] header = new Object[metaData.getColumnCount()];

        for (int i = 0; i < header.length; i++) {
            header[i] = metaData.getColumnName(i+1);
            System.out.println(header[i]);
        }

        while (set.next()) {
            Object[] row = new Object[header.length];
            for (int i = 0; i < row.length; i ++) {
                row[i] = set.getString(i+1);
                System.out.print(row[i] + " ");

            }
        }
            return null;

    }

    /*
        how much realty does the company
     */
    public static int agregate_function(int ra_id) throws SQLException {
        Statement statement = connection.createStatement();
        ResultSet set = statement.executeQuery("select count(*) from REALTY_AGENCIES join REALTY R2 on REALTY_AGENCIES.RA_ID = R2.RA_ID\n" +
                "where REALTY_AGENCIES.RA_ID  = 1;");

        ResultSetMetaData metaData = set.getMetaData();

        Object[] header = new Object[metaData.getColumnCount()];

        for (int i = 0; i < header.length; i++) {
            header[i] = metaData.getColumnName(i+1);
            System.out.println(header[i]);
        }

        while (set.next()) {
            Object[] row = new Object[header.length];
            for (int i = 0; i < row.length; i ++) {
                row[i] = set.getString(i+1);
                System.out.print(row[i] + " ");

            }
        }

        return 0;
    }


    public JDBCConnection() throws SQLException {

    }


    public static void main (String args[]) throws SQLException
    {


        DatabaseMetaData meta = connection.getMetaData();
        Statement statement = connection.createStatement();


       get_ra_by_id(1);
        // gets driver info:
    }
}