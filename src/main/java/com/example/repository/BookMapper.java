package com.example.repository;

import com.example.entity.Bible;
import com.example.entity.Book;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface BookMapper {
    public List<Book> bookList();
    public void saveBook(Book dto);
    public void bibleInsert(Bible bible);
}
