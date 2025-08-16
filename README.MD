Ansible Automated Database Setup
================================

Overview
--------

This Ansible playbook is designed to automate the deployment and configuration of database management systems on an Ubuntu VPS with minimal human intervention. It allows for the automatic installation and configuration of:

*   MySQL databases, including database creation, user configuration, and data import.
    
*   PostgreSQL databases (role scaffolded for future expansion).
    
*   phpMyAdmin for web-based MySQL database management.
    

The playbook is modular, organized into **roles**, making it reusable and scalable. Each role encapsulates a specific part of the system, allowing independent execution and easy customization.

* * *

Features
--------

*   Fully automated installation and configuration of MySQL and PostgreSQL servers.
    
*   Automatic creation of databases and users.
    
*   SQL file imports into MySQL.
    
*   Automated setup of phpMyAdmin with Nginx or Apache integration.
    
*   Centralized configuration through `vars` and `defaults`.
    
*   Handlers for service management to ensure system changes are applied safely.
    
*   Scalable and reusable playbook suitable for multiple servers.
    

* * *

Repository Structure
--------------------

```.
│   .gitignore
│   inventory.ini
│   inventory.sample.ini
│   playbook.yml
│   README.MD
│
├───roles
│   ├───db_mysql
│   ├───db_postgres
│   └───phpmyadmin
└───vars
``` 

### Description of Key Files

*   **.gitignore** – Standard file to ignore unwanted files from Git.
    
*   **inventory.ini** – Ansible inventory file defining target hosts.
    
*   **inventory.sample.ini** – Sample inventory file demonstrating configuration format.
    
*   **playbook.yml** – Main playbook to execute all roles sequentially.
    
*   **roles/** – Contains modular Ansible roles for different services.
    
*   **vars/** – Global variables used across roles.
    

* * *

Roles
-----

### 1\. `db_mysql` – MySQL Database Setup

This role handles the complete installation, configuration, and initialization of MySQL databases.

#### Folder Structure

`roles/db_mysql
│   defaults/main.yml
│   files/
│   handlers/main.yml
│   tasks/
│   templates/mysqld.cnf.j2
│   vars/db_kseco_ch.yml` 

#### Key Components:

*   **defaults/main.yml** – Default MySQL variables such as ports, root password, and database names.
    
*   **files/** – SQL files to be imported automatically during setup.
    
*   **handlers/main.yml** – Contains restart/reload handlers for MySQL service when configuration changes.
    
*   **tasks/** – Subtasks broken down into:
    
    *   `install.yml` – Installs MySQL server.
        
    *   `configure.yml` – Updates MySQL configuration using templates.
        
    *   `databases.yml` – Creates databases and users.
        
    *   `imports.yml` – Imports SQL files into created databases.
        
    *   `backups.yml` – Optional automated backups.
        
    *   `test.yml` – Checks database connectivity and basic setup.
        
    *   `main.yml` – Calls all subtasks in order.
        
*   **templates/mysqld.cnf.j2** – Template for MySQL configuration allowing dynamic customization.
    
*   **vars/db\_kseco\_ch.yml** – Role-specific variables for database names, users, and credentials.
    

* * *

### 2\. `db_postgres` – PostgreSQL Database Setup

Currently scaffolded for future expansion. When implemented, this role will include:

*   Installation of PostgreSQL server.
    
*   Creation of databases and roles.
    
*   Configuration of access privileges.
    
*   Optional SQL imports.
    

The structure mirrors `db_mysql` to ensure consistency and reusability.

* * *

### 3\. `phpmyadmin` – phpMyAdmin Setup

This role automates the deployment of phpMyAdmin on Ubuntu servers for web-based database management.

#### Folder Structure

```
roles/phpmyadmin
│   handlers/main.yml
│   tasks/
│   templates/
``` 

#### Key Components:

*   **tasks/main.yml** – Main task to install phpMyAdmin and dependencies.
    
*   **tasks/nginx.yml** – Configures Nginx to serve phpMyAdmin.
    
*   **tasks/phpmyadmin.yml** – Configures phpMyAdmin application settings.
    
*   **handlers/main.yml** – Handles web server reloads after configuration changes.
    
*   **templates/apache-phpmyadmin.conf.j2** – Apache virtual host configuration for phpMyAdmin.
    
*   **templates/nginx-phpmyadmin.conf.j2** – Nginx server block configuration for phpMyAdmin.
    

* * *

Inventory Setup
---------------

The playbook uses an inventory file to define target servers.

**Example `inventory.sample.ini`:**

`[database_servers]
vps1 ansible_host=192.168.1.10 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/id_rsa` 

*   `[database_servers]` – Group for database servers.
    
*   `ansible_host` – IP address or hostname of the target VPS.
    
*   `ansible_user` – SSH user.
    
*   `ansible_ssh_private_key_file` – Path to SSH private key.
    

You can copy this sample file to `inventory.ini` and customize for your server environment.

* * *

Playbook Execution
------------------

Run the playbook with the following command:

`ansible-playbook -i inventory.ini playbook.yml` 

This command will sequentially execute all roles:

1.  Install and configure MySQL.
    
2.  Set up databases, users, and imports.
    
3.  Install phpMyAdmin with proper web server configuration.
    
4.  (Future) PostgreSQL setup.
    

* * *

Variables
---------

Variables are organized in two ways:

1.  **Role Defaults** – Located in `roles//defaults/main.yml`. These are default values that can be overridden.
    
2.  **Role Vars** – Located in `roles//vars/.yml`. These are more specific settings for each role, such as database names, credentials, or SQL files to import.
    

* * *

Handlers
--------

Handlers allow services to restart automatically after configuration changes:

*   MySQL service restart after configuration updates.
    
*   Web server reload after phpMyAdmin setup.
    

* * *

Templates
---------

Templates are Jinja2 files used to dynamically generate configuration files.

*   `mysqld.cnf.j2` – MySQL server configuration template.
    
*   `apache-phpmyadmin.conf.j2` and `nginx-phpmyadmin.conf.j2` – Web server configurations for phpMyAdmin.
    

* * *

Notes
-----

*   This playbook is designed for Ubuntu Linux servers.
    
*   All SQL imports in `roles/db_mysql/files/` are optional and executed automatically if present.
    
*   PostgreSQL role is currently empty but scaffolded for future development.
    

* * *

Contribution
------------

Contributions are welcome! If you want to add features or improve existing roles:

1.  Fork the repository.
    
2.  Create a feature branch.
    
3.  Submit a pull request with a detailed description of your changes.
    

* * *

License
-------

MIT License 