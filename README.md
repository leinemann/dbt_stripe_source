[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=0.20.x&color=orange)
# Stripe 

This package models Stripe data from [Fivetran's connector](https://fivetran.com/docs/applications/stripe). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/stripe#schemainformation).

This package enriches your Fivetran data by doing the following:
* Add descriptions to tables and columns that are synced using Fivetran
* Add freshness tests to source data
* Add column-level testing where applicable. For example, all primary keys are tested for uniqueness and non-null values.
* Model staging tables, which will be used in our transform package

## Models

This package contains staging models, designed to work simultaneously with our [Stripe modeling package](https://github.com/fivetran/dbt_stripe).  The staging models are designed to:
* Remove any rows that are soft-deleted
* Name columns consistently across all packages:
    * Boolean fields are prefixed with `is_` or `has_`
    * Timestamps are appended with `_at`
    * ID primary keys are prefixed with the name of the table.  For example, the card table's ID column is renamed `card_id`.


## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

Include in your `packages.yml`

```yaml
packages:
  - package: fivetran/stripe_source
    version: [">=0.4.0", "<0.5.0"]
```

## Configuration
By default, this package will look for your Stripe data in the `stripe` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Stripe data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    stripe_schema: your_schema_name
    stripe_database: your_database_name 
```

### Disabling Models
This package takes into consideration that not every Stripe account utilizes the `invoice`, `invoice_line_item`, `payment_method`, `payment_method_card`, `plan`, or `subscription` features, and allows you to disable the corresponding functionality. By default, all variables' values are assumed to be `true`. Add variables for only the tables you want to disable:

```yml
# dbt_project.yml

...
vars:
    using_invoices:        False  #Disable if you are not using the invoice and invoice_line_item tables
    using_payment_method:  False  #Disable if you are not using the payment_method and payment_method_card tables
    using_subscriptions:   False  #Disable if you are not using the subscription and plan tables.

```

### Changing the Build Schema
By default this package will build the Stripe staging models within a schema titled (<target_schema> + `_stg_stripe`). If this is not where you would like your Stripe staging models to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
  stripe_source:
    +schema: my_new_staging_models_schema # leave blank for just the target_schema

```

*Read more about using custom schemas in dbt [here](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/using-custom-schemas).*

### Running on Live vs Test Customers
By default, this package will run on non-test data (`where livemode = true`) from the source Stripe tables. However, you may want to include and focus on test data when testing out the package or developing your analyses. To run on _only_ test data, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

vars:
    stripe_source:
        using_livemode: false  # Default = true
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Database support
This package has been tested on BigQuery, Snowflake, and Redshift.

### Resources:
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Have questions, feedback, or need help? Book a time during our office hours [using Calendly](https://calendly.com/fivetran-solutions-team/fivetran-solutions-team-office-hours) or email us at solutions@fivetran.com
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Learn how to orchestrate [dbt transformations with Fivetran](https://fivetran.com/docs/transformations/dbt)
- Learn more about Fivetran overall [in our docs](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

