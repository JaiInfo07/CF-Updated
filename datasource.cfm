<cfscript>
    // Credentials
    adminUsername = "admin";

    // Database Details
    datasourceName = "BillingSystem";
    dbServer = "16.171.55.133";
    dbName = "BillingSystem";
    dbPort = "1433";
    dbUsername = "SA";
    dbPassword = "Admin@123";
    dbDriver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";

    // Login to ColdFusion Admin
    adminObj = createObject("component", "cfide.adminapi.administrator");
    adminObj.login(adminUsername);

    // Add the datasource
    datasourceObj = createObject("component", "cfide.adminapi.datasource");
    datasourceObj.setMSSQL(
        datasourceName, 
        dbServer, 
        dbName, 
        dbUsername, 
        dbPassword, 
        dbPort, 
        ""
    );
</cfscript>

