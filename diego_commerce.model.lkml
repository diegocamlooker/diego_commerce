connection: "thelook"

include: "*.view.lkml" # include all the views in this project

include: "*.dashboard.lookml"  # include all dashboards in this project

datagroup: long_persistence {
  max_cache_age: "24 hours"
  #more info: https://docs.looker.com/data-modeling/learning-lookml/caching
  sql_trigger: select current_date ;;
}

explore: order_items {

  fields: [ALL_FIELDS*,-users.name] # excluding customer names from the analysis
  persist_with: long_persistence # added 4h refresh with the data
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

  fields: [ALL_FIELDS*,-users.name] # excluding customer names from the analysis
  join:  users{
    type: inner # every order has to have a user
    view_label: "Customers" # https://docs.looker.com/reference/explore-params/view_label-for-join
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  group_label: "Diego Commerce"
  description: "View orders"
  label: "Orders 2010"
  sql_always_where: ${users.age}>'18' ;; # only info from user above 18
  always_filter: {
    filters: {
      field: users.created_year # we only get the data from the 2010
      value: "2010"
    }
  }
}

explore: users {
  group_label: "Diego Commerce"
  description: "View the users of the platform"
  label: "Users"
}

explore: users_facts {
  persist_with: long_persistence
  group_label: "Diego Commerce"
  description: "View the users facts"
  label: "Users facts"


}
