package net.demo.redis_demo.dao;

import net.demo.redis_demo.entity.User;
import org.beetl.sql.core.mapper.BaseMapper;
import org.springframework.stereotype.Component;

@Component
public interface UserDao extends BaseMapper<User> {
    User find(Long id);
}
