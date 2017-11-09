view: users_facts {
    derived_table: {
      sql: SELECT orders.user_id AS user_id
        , COUNT(*) AS lifetime_orders
        , MIN(orders.created_at) AS first_order
        , MAX(NULLIF(orders.created_at,0)) AS latest_order
        , DATEDIFF(MAX(NULLIF(orders.created_at,0)),MIN(NULLIF(orders.created_at,0))) AS days_as_customer
        , DATEDIFF(CURDATE(),MAX(NULLIF(orders.created_at,0))) AS days_since_purchase
        , COUNT(DISTINCT MONTH(NULLIF(orders.created_at,0))) AS number_of_distinct_months_with_orders
      FROM orders
      WHERE {% condition user_id %} orders.user_id {% endcondition %}
      GROUP BY user_id
       ;;
      indexes: ["user_id"]
      #sql_trigger_if: SELECT 0 ;;
    }

    #     sql_trigger_value: SELECT CURDATE()
    # DIMENSIONS #

    filter: month_test {
      type: date
    }

    filter: user_test {
      type: string
    }

    dimension: user_id {
      primary_key: yes
      #hidden: yes
    }

    dimension: lifetime_orders {
      type: number
    }

    dimension: lifetime_number_of_orders_tier {
      type: tier
      tiers: [
        0,
        1,
        2,
        3,
        5,
        10
      ]
      sql: ${lifetime_orders} ;;
    }

    dimension: repeat_customer {
      type: yesno
      sql: ${lifetime_orders} > 1 ;;
    }

    dimension_group: first_order {
      type: time
      timeframes: [date, week, month]
      sql: ${TABLE}.first_order ;;
    }

    dimension_group: latest_order {
      type: time
      timeframes: [date, week, month, year]
      sql: ${TABLE}.latest_order ;;
    }

    dimension: days_as_customer {
      type: number
    }

    dimension: test_years {
      type: number
      sql: ${days_as_customer} ;;
      html:
      {% assign num_years = value | divided_by:365 %}
      {% if num_years > 0 %}
      {{ num_years }} years
      {%endif%}
      {{ value | modulo:365 }} days ;;
    }

    dimension: days_as_customer_tiered {
      type: tier
      tiers: [0, 10, 50, 100, 500]
      sql: ${days_as_customer} ;;
    }

    dimension: days_since_purchase {
      type: number
    }

    dimension: number_of_distinct_months_with_orders {
      type: number
    }

    measure: count {
      type: count
    }

  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: users_facts {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
