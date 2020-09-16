package net.demo.redis_demo;

import lombok.extern.slf4j.Slf4j;
import net.demo.redis_demo.RedisDemoApplicationTests;
import net.demo.redis_demo.entity.User;
import net.demo.redis_demo.service.userService.UserService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.core.StringRedisTemplate;

import java.io.Serializable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.stream.IntStream;

@Slf4j
public class RedisTest extends RedisDemoApplicationTests {

    @Autowired
    private StringRedisTemplate stringRedisTemplate;

    @Autowired
    private RedisTemplate<String, Serializable> redisTemplate;

    /**
     * 测试 Redis 操作
     */
    @Test
    public void get() {
        stringRedisTemplate.opsForValue().set("k1", "v1");
        String k1 = stringRedisTemplate.opsForValue().get("k1");
        log.debug("【k1】= {}", k1);

        // 以下演示整合，具体Redis命令可以参考官方文档
        String key = "szsti:user:1";
        redisTemplate.opsForValue().set(key, User.builder().id(1L).name("user1").build());
        // 对应 String（字符串）
        User user = (User) redisTemplate.opsForValue().get(key);
        log.debug("【user】= {}", user);

        // 测试线程安全，程序结束查看redis中count的值是否为1000
        ExecutorService executorService = Executors.newFixedThreadPool(1000);
        IntStream.range(0, 1000).forEach(i -> executorService.execute(() -> stringRedisTemplate.opsForValue().increment("count", 1)));
    }

}
