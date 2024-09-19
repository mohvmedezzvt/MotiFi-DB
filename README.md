# MotiFi-DB

This repository contains the documentation for setting up and managing the MotiFi database, to view the ERD click: [MotiFi Database ERD](https://app.eraser.io/workspace/r0nmflZDxR5oUC9GVqAl?origin=share)

## Table of Contents

1. [Set up AWS RDS for PostgreSQL](#set-up-aws-rds-for-postgresql)
2. [Implement Security Measures](#implement-security-measures)
3. [Database Migration](#database-migration)
4. [Set Up Monitoring](#set-up-monitoring)
5. [Implement Backup and Recovery](#implement-backup-and-recovery)

## Set up AWS RDS for PostgreSQL

To create the production database instance on AWS RDS, follow these steps:

1. Log into the AWS Console and navigate to RDS.
2. Click "Create database" and choose the following options:

- Engine type: PostgreSQL
- Version: Choose the latest stable version
- Template: Production
- DB instance identifier: Choose a meaningful name (e.g., "lms-production")
- Master username: Create a secure username
- Master password: Generate a strong password and store it securely

3. Configure the instance based on your requirements, including connectivity, additional configuration, and maintenance settings.
4. After the database is created, note the endpoint, port, and other connection details.
5. Update your application's database configuration to use these new details.
6. Test the connection from your application servers.

## Implement Security Measures

To secure the RDS instance, follow these steps:

1. Use AWS Secrets Manager to store database credentials:

- Go to AWS Secrets Manager in the AWS Console.
- Create a new secret for your RDS instance credentials.
- Update your application code to retrieve credentials from Secrets Manager.

2. Set up IAM roles for database access:

- Create an IAM role for your application to access the RDS instance.
- Attach the appropriate policies (e.g., AmazonRDSFullAccess).
- Assign this role to your application servers (EC2 instances or ECS tasks).

3. Configure VPC security groups:

- Ensure the security group allows inbound traffic only from your application servers.
- Restrict outbound traffic as necessary.

## Database Migration

To manage database migrations, follow these steps:

1. Install Flyway:

```
wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/7.8.2/flyway-commandline-7.8.2-linux-x64.tar.gz | tar xvz && sudo ln -s `pwd`/flyway-7.8.2/flyway /usr/local/bin
```

2. Create a Flyway configuration file (flyway.conf):

```
flyway.url=jdbc:postgresql://<your-rds-endpoint>:5432/lms_production
flyway.user=<your-db-username>
flyway.password=<your-db-password>
```

3. Create a "migrations" directory.
4. Move your existing SQL script into the migrations directory.
5. Run the migration:

```
flyway migrate
```

6. For future migrations, create new migration files in the "migrations" directory and run `flyway migrate` to apply them.

## Set Up Monitoring

To configure monitoring for your RDS instance, follow these steps:

1. Set up CloudWatch alarms for:

- High CPU utilization
- Low free storage space
- High database connections

2. Enable Performance Insights:

- Go to your RDS instance in the AWS Console.
- Click on "Performance Insights" in the navigation pane.
- Start analyzing query performance.

3. Set up RDS Event Notifications:

- In the RDS Console, go to "Event subscriptions".
- Create a new event subscription for important database events.

## Implement Backup and Recovery

To ensure your backup strategy is in place, follow these steps:

1. Verify automated backups are enabled (should be from RDS setup).
2. Consider setting up cross-region replication for disaster recovery.
3. Test the restoration process using a backup.
