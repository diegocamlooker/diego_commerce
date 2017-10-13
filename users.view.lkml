view: users {
  sql_table_name: dbo.USERS ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.AGE ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.CREATED_AT ;;
  }

  dimension: epoch_at {
    type: number
    sql: ${TABLE}.EPOCH_AT ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.NAME ;;
  }

  dimension: yyyymmdd_at {
    type: number
    sql: ${TABLE}.YYYYMMDD_AT ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, orders.count]
  }
}
