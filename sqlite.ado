********************************************************************************
* Program         : sqlite.ado                                                 *
* Purpose         : import and export of SQLite3 databases                     *
*                 :                                                            *
* Syntax          : sqlite mode dbname sql                                     *
*                 :                                                            *
*                 : Where mode is either import or export                      *
*                 :       dbname is a database name                            * 
*                 :       sql is an SQL query when importing data and a table  * 
*                 :       name when exporting                                  *
*                 :                                                            *
* Programmer      : Jonas Ranstam                                              *
* Programmed date : 24.02.2019                                                 *
********************************************************************************

*! sqlite3 v1.0.0 JRanstam 24feb2019

program define sqlite
   version 14

   args mode dbname sql
  
   if ("`mode'"=="import") {
      !sqlite3 -csv -header `dbname' "`sql'" > temp.csv
      import delimited temp.csv, clear varnames(1)
      erase temp.csv
   } 
   else if ("`mode'"=="export") {
      export delimited using "temp.csv", nolabel quote replace
      if ("`c(os)'"=="Unix" | "`c(os)'"=="MacOSX") {
         !echo -e "\n.import temp.csv `sql'" | sqlite3 -separator , `dbname'
      }
      if ("`c(os)'"=="Windows") {
         display " "
         display "This function is not available when running Stata under Windows."
         display " "
      }
      erase temp.csv
   }  
   else {
      display " "
      display "Incorrect command, see help sqlite!"
      display " "
   }
end

