**Simple Backup Tool - User Guide**
===================================

This guide explains how to use the **Simple Backup Tool**, a bash script that helps you back up web directories and MySQL databases with optional descriptions.

**📥 Installation**
-------------------

1.  shCopynano backup\_tool.shPaste the script content and save (Ctrl+O, Enter, Ctrl+X).
    
2.  shCopychmod +x backup\_tool.sh
    
3.  shCopy./backup\_tool.sh
    

**🔄 How It Works**
-------------------

### **1️⃣ Web Directory Backup**

*   **Input**:
    
    *   **Source Directory**: Path to the folder you want to back up.
        
    *   **Destination Directory**: Where the backup will be saved.
        
    *   **Filename**: Default includes timestamp (e.g., web\_backup\_20240125\_142022.tar.gz).
        
    *   **Description (Optional)**: Add notes about the backup.
        
*   **Output**:
    
    *   A compressed .tar.gz backup file.
        
    *   A README\_\*.txt file with details (if description was added).
        

### **2️⃣ MySQL Database Backup**

*   **Input**:
    
    *   **MySQL Credentials**: Username, password, and host (default: localhost).
        
    *   **Select Databases**: Choose which databases to back up.
        
    *   **Filename**: Default includes database name and timestamp (e.g., db\_backup\_mydb\_20240125\_142022.sql.gz).
        
    *   **Description (Optional)**: Add notes about the backup.
        
*   **Output**:
    
    *   A compressed .sql.gz file for each database.
        
    *   A README\_\*.txt file for each backup (if description was added).
        

**📜 Example Usage**
--------------------

### **Backing Up a Web Directory**

1.  shCopy./backup\_tool.sh
    
2.  Choose **"Backup web directory?"** (y).
    
3.  Enter:
    
    *   **Source Directory**: /var/www/mywebsite
        
    *   **Destination Directory**: ~/backups
        
    *   **Filename**: (Press Enter for default or type a custom name)
        
    *   **Description**: (Optional) "Main website backup before updates"
        

✅ **Output**:

*   ~/backups/web\_backup\_20240125\_142022.tar.gz
    
*   ~/backups/README\_web\_backup\_20240125\_142022.txt
    

### **Backing Up MySQL Databases**

1.  shCopy./backup\_tool.sh
    
2.  Choose **"Backup MySQL databases?"** (y).
    
3.  Enter:
    
    *   **MySQL Username**: root
        
    *   **MySQL Password**: (hidden input)
        
    *   **MySQL Host**: (Press Enter for localhost)
        
    *   **Select Databases**: Choose from the list (e.g., mydb).
        
    *   **Filename**: (Press Enter for default or type a custom name)
        
    *   **Description**: (Optional) "Production DB backup before migration"
        

✅ **Output**:

*   ~/backups/db\_backup\_mydb\_20240125\_142022.sql.gz
    
*   ~/backups/README\_db\_backup\_mydb\_20240125\_142022.txt
    

**🔍 Viewing Backup Details**
-----------------------------

Each backup generates a **README file** with:

*   **Date & Time**
    
*   **Backup Name & Location**
    
*   **Size**
    
*   **Description** (if provided)
    

Example README\_\*.txt:

Copy

Plain textANTLR4BashCC#CSSCoffeeScriptCMakeDartDjangoDockerEJSErlangGitGoGraphQLGroovyHTMLJavaJavaScriptJSONJSXKotlinLaTeXLessLuaMakefileMarkdownMATLABMarkupObjective-CPerlPHPPowerShell.propertiesProtocol BuffersPythonRRubySass (Sass)Sass (Scss)SchemeSQLShellSwiftSVGTSXTypeScriptWebAssemblyYAMLXML`   Backup Information  =================  Date: Fri Jan 25 14:20:22 UTC 2024  Backup Name: web_backup_20240125_142022.tar.gz  Location: /home/user/backups  Size: 245M  Description:  Main website backup before updates   `

**🛑 Troubleshooting**
----------------------

**IssueSolution"Directory doesn't exist!"**Check the path and try again.**"No databases found!"**Verify MySQL credentials and permissions.**Backup fails**Ensure enough disk space in the destination.**Script permission denied**Run chmod +x backup\_tool.sh.

**📌 Tips**
-----------

✔ **Store backups securely** (cloud/external drive).✔ **Test restoring backups** to ensure they work.✔ **Use descriptions** to remember why each backup was made.

### **🚀 Ready to Use?**

Run the script and start backing up!


`   ./backup_tool.sh   `
