package lab4;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import oracle.jdbc.OracleResultSet;
import oracle.jdbc.pool.OracleDataSource;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.sql.STRUCT;
import oracle.sql.StructDescriptor;

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
                " REALTY_AGENCIES WHERE RA_ID = " + id );

        set.next();
        return set.getString(1);

    }

    /*
        Возвращает какое количество имущества имеется у Агенства под id:
     */
    public static int agregate_function(int ra_id) throws SQLException {
        Statement statement = connection.createStatement();
        ResultSet set = statement.executeQuery("select count(R2.REALTY_ID) from REALTY_AGENCIES join REALTY R2 on REALTY_AGENCIES.RA_ID = R2.RA_ID\n" +
                "where REALTY_AGENCIES.RA_ID  = " + ra_id);

        set.next();
        int number= set.getInt(1);


        return number;
    }




    public static ARRAY table_function(int id) throws SQLException {
        Statement statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet price = statement.executeQuery("SELECT CADASTRAL_PRICE FROM REALTY " +
                "WHERE realty_id = " + id);
        price.next();
        Long price_number =  price.getLong(1);

        ResultSet customers =  statement.executeQuery("SELECT customer_id,  last_name, first_name FROM customers WHERE " +
                "wealth > " + price_number);

        int rowcount =0;

        if (customers.last()) {
            rowcount = customers.getRow();
            customers.beforeFirst();
        }

        StructDescriptor cus_java = StructDescriptor.createDescriptor("MELTIK.CUSTOMERS_JAVA", connection);
        ArrayDescriptor table_of_cus_java = ArrayDescriptor.createDescriptor("MELTIK.CUSTOMERS_JAVA_TABLE", connection);

        STRUCT[] table = new STRUCT[rowcount];
        //new ARRAY(table_of_cus_java, connection, new ARRAY[rowcount]);
        int i =0;
        while (customers.next()) {
            Object[] values = new Object[customers.getMetaData().getColumnCount()];
            values[0] = customers.getInt(1);
            values[1] = customers.getString(2);
            values[2] = customers.getString(3);
            STRUCT customer = new STRUCT(cus_java, connection, values);
            table[i] = customer;
            i++;
        }

        ARRAY res = new ARRAY(table_of_cus_java, connection, table);

        return res;
    }

    /*
         fast insert realty
     */


    public static int procedure() throws SQLException {
        Random random = new Random();
        int loc_id = random.nextInt(99);
        int realty_id = random.nextInt(10);
        int price = random.nextInt(1000000);
        int rent_price = random.nextInt(1000);
        String commercial = "Y";
        String pattern = "yyyy-MM-dd";
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(pattern);
        String  date = simpleDateFormat.format(new Date());

        StringBuilder stringBuilder = new StringBuilder();
        stringBuilder.append(loc_id).append(",").append(realty_id).append(",").append(price).append(",");
        stringBuilder.append(rent_price).append(",'").append(commercial).append("',").append("TO_DATE('" + date + "', 'YYYY-MM-DD')");

        String query = "INSERT INTO REALTY " +
                "(LOCATION_ID, RA_ID, CADASTRAL_PRICE, " +
                "RENT_PRICE, IS_COMMERCIAL, DATE_OF_BUILDING) values(" + stringBuilder +")";

        Statement statement = connection.createStatement();
        Boolean status = statement.execute(query);
        return 0;
    }

    public static int trigger(int realty_id, int customer_id) throws SQLException {
        String realty_price = "SELECT RENT_PRICE FROM REALTY WHERE realty_id = " + realty_id;
        Statement statement = connection.createStatement();
        ResultSet price_set = statement.executeQuery(realty_price);
        Long price = 0L;
        while (price_set.next()) {
             price = price_set.getLong(1);
        }

        String update_balance = "UPDATE customers " +
                "SET wealth = wealth - " + price
                + "WHERE CUSTOMER_ID = " + customer_id;

        statement.execute(update_balance);

        return 0;
    }


    public static oracle.sql.STRUCT struct(int id) throws SQLException {
        StructDescriptor personSD =
                StructDescriptor.createDescriptor("MELTIK.CUSTOMERS_T", connection);
        Object[] attrs = new Object[2];

        Statement statement = connection.createStatement();
        String query  = "SELECT CUSTOMER_ID, LAST_NAME FROM CUSTOMERS WHERE CUSTOMER_ID = " + id;
        ResultSet set = statement.executeQuery(query);

        set.next();
        String last_name = set.getString(2);
        int cus_id = set.getInt(1);

        attrs[0] = cus_id;
        attrs[1] = last_name;

        STRUCT person  = new STRUCT(personSD, connection, attrs);
        return person;
    }

}