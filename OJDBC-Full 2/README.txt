OJDBC-FULL.tar.gz - JDBC Thin Driver and Companion JARS
========================================================
This TAR archive (ojdbc-full.tar.gz) contains the 12.1.0.2 release of the Oracle JDBC Thin driver (ojdbc7.jar for JDK7 and JDK8 and ojdbc6.jar for JDK6), the Universal Connection Pool (ucp.jar) and other companion JARs grouped by category. 

(1) ojdbc7.jar (3,698,857 bytes) - (SHA1 Checksum: 7c9b5984b2c1e32e7c8cf3331df77f31e89e24c2)
Certified with JDK7 and JDK 8; It contains the JDBC driver classes except classes for NLS support in Oracle Object and Collection types.

(2) ojdbc6.jar (3,692,096 bytes) - (SHA1 Checksum: 76f2f84c383ef45832b3eea6b5fb3a6edb873b93)
For use with JDK 6; It contains the JDBC driver classes except classes for NLS support in Oracle Object and Collection types. 

(3) ucp.jar (733,729 bytes) - (SHA1 Checksum:384b4a763188849bfd68f313701ac11dafd1899b)
(Refer MOS note DOC ID 2074693.1) - UCP classes for use with JDK 6 & JDK 7

(4) ojdbc.policy (10,542 bytes) - Sample security policy file for Oracle Database JDBC drivers

=============================
JARs for NLS and XDK support 
=============================
(5) orai18n.jar (1,659,574 bytes) - (SHA1 Checksum: 11969072d3de96bfd5b246071976e274d78598a7) - Classes for NLS support

(6) xdb6.jar (253,006 bytes) - (SHA1 Checksum: 6fbdaebf59cb33282548f4df14436cc179c64bee)
Classes to support standard JDBC 4.x java.sql.SQLXML interface (Java SE 6 & Java SE 7).

====================================================
JARs for Real Application Clusters(RAC), ADG, or DG 
====================================================

(7) simplefan.jar (21,189 bytes) - (SHA1 Checksum: 80ca1246d5c9cad79985e9fff0acc9fb09ba1b2b)
Java APIs for subscribing to RAC events via ONS; simplefan policy and javadoc

(8) ons.jar (106,496 bytes) - (SHA1 Checksum: 1aee60b3f7aa581d90f2f18d5e334a1913da52c9)
for use by the pure Java client-side Oracle Notification Services (ONS) daemon

=================
OTHER RESOURCES
=================
Refer to the 12.1 JDBC Developers Guide (https://docs.oracle.com/database/121/JJDBC/toc.htm) and Universal Connection Pool Developers Guide (https://docs.oracle.com/database/121/JJUCP/toc.htm) for more details. 
