package net.demo.redis_demo.service.userService;

import lombok.extern.slf4j.Slf4j;
import net.demo.redis_demo.dao.UserDao;
import net.demo.redis_demo.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
@Slf4j
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;


    public User get(Long id) {
        // 我们假设从数据库读取
        log.info("查询用户【id】= {}", id);
        return userDao.single(id);
    }

    public User saveOrUpdate(User user) {
        userDao.insert(user);
        log.info("保存用户【user】= {}", user);
        return user;
    }

    public void delete(Long id) {
        userDao.deleteById(id);
        log.info("删除用户【id】= {}", id);
    }
}
