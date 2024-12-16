<cfscript>
adminObj = createObject("component", "cfide.adminapi.administrator");
dataSourceObj = createObject("component", "cfide.adminapi.datasource");
dataSourceObj.setMSSQL(
    "BillingSystem",
    "13.61.145.48",
    1433,
    "BillingSystem",
    "SA",
    "Admin@123",
    "",
    false,
    false
);
</cfscript>
