package com.example.repository;

import com.example.entity.Book;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BookMapper {
    public List<Book> bookList();
    public void saveBook(Book dto);

}
