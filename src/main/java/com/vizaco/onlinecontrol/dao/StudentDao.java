package com.vizaco.onlinecontrol.dao;

import com.vizaco.onlinecontrol.model.Student;
import org.springframework.dao.DataAccessException;

import java.util.Collection;
import java.util.List;

public interface StudentDao {

    Student findById(Long id) throws DataAccessException;

    List<Student> findByLastName(String lastName) throws DataAccessException;

    List<Student> getAllStudents() throws DataAccessException;

    void save(Student student) throws DataAccessException;

}
