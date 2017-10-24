connection: "thelook"


include: "*.view.lkml" # include all the views in this project

include: "*.dashboard.lookml"  # include all dashboards in this project

datagroup: long_persistence {
  max_cache_age: "4 hours"
  #more info: https://docs.looker.com/data-modeling/learning-lookml/caching
  sql_trigger: select current_date ;;
}


explore: order_items {
  persist_with: long_persistence
  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }
  join: users {
    type: inner
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
