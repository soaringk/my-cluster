package net.demo.redis_demo.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User implements Serializable {

    private static final long serialVersionUID = 2892248514883451461L;

    private Long id;
    private String name;
    private Integer age;
    private String userName;
    private Integer roleId;
    private Date date;

}
