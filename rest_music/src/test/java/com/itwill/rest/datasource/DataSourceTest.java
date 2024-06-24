package com.itwill.rest.datasource;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit.jupiter.SpringExtension;

import com.zaxxer.hikari.HikariDataSource;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@ExtendWith(SpringExtension.class)
@ContextConfiguration(
		locations = { "file:src/main/webapp/WEB-INF/application-context.xml" }
)
public class DataSourceTest {
	
	
	@Autowired
	private HikariDataSource ds;
	
	@Autowired
	private SqlSessionFactoryBean session;
	
	@Test
	public void test() {
		Assertions.assertNotNull(ds);
		log.debug("ds = {}", ds);
		
		Assertions.assertNotNull(session);
		log.debug("session = {}", session);
	}
	
}


