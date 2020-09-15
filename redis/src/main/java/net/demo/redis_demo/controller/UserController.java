package net.demo.redis_demo.controller;

import net.demo.redis_demo.entity.User;
import net.demo.redis_demo.service.userService.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/get")
    public User getUser(@RequestParam(value = "id") Long id) {
        User user = userService.get(id);
        return user;
    }

    @GetMapping("/up")
    public User UpdateUser(@RequestParam(value = "id") Long id,
                           @RequestParam(value = "name") String name) {
        userService.saveOrUpdate(User.builder().id(id).name(name).build());

        User user = userService.get(id);
        return user;
    }

    @GetMapping("/del")
    public User delUser(@RequestParam(value = "id") Long id) {
        User user = userService.get(id);
        userService.delete(id);
        return user;
    }

}
