package capstone.backend.timeblock.domain;

import jakarta.persistence.Column;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

public class TimeBlock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Long userId;

    @Column(nullable = false)
    private String dayOfWeek;

    @Column(nullable = false)
    private int startHour;

    @Column(nullable = false)
    private int endHour;

    @Column
    private String taskTitle;

}
