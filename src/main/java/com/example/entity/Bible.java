package com.example.entity;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Bible {
    private int bible_num;
    private String customer_id;
    private String bible_word;
    private String bible_repent;
    private String bible_things;
    private String bible_implement;
    private Date bible_date;
}
