package com.example.controller;

import com.example.entity.Book;
import com.example.entity.Customer;
import com.example.repository.BookMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
public class SpringRestController {

    @Autowired
    private BookMapper mapper;
   // http://localhost:8081/myweb/rest
    @RequestMapping("/rest")
    public  List<String> rest(){
        List<String> list=new ArrayList<>();
        list.add("스프링 프레임워크");
        list.add("잘 하면");
        list.add("된다");
        return list; // rest.jsp <-- 뷰를 만들면 된다.(X) : JSON -> [{ key:value,   ,    ,}.{     },{    }]
    }

    @RequestMapping("/restlist")
    public List<Book> list(){
        List<Book> list=mapper.bookList();
        return list; // list->[ {       }, {       }, {        } ]
    }

    @PostMapping("/restsave")
    public String saveBook(@RequestBody  Book dto){
         mapper.saveBook(dto);
        return "success";
    }

    @GetMapping("/api/customers")
    public List<Customer> customers(){
         List<Customer> customers=mapper.customers();
         return customers; // JSONArray [ {     },{     },{     } ]
    }
}
