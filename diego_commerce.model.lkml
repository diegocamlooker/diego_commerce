connection: "aaa_test_azure_sql_dw"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: all_types {
  hidden: yes
}

explore: order_items {
  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;

    relationship: many_to_one
  }
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  description: "View the items on the orders"
  group_label: "Diego Commerce"
  label: "Order Items"
}
explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  group_label: "Diego Commerce"
  description: "View orders"
  label: "Order"
}

explore: temp {
  hidden: yes
}

explore: users {
  group_label: "Diego Commerce"
  description: "View the users of the platform"
  label: "Users"
}
