package com.example.entity;

import lombok.Data;

@Data
public class Customer {
     private String customer_id;
     private String password;
     private String customer_name ;
     private int age;
     private String rating;
     private String occupation;
     private int reserves;
}
