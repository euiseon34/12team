package capstone.backend.schedule;

import capstone.backend.user.User;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Task {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false) // 제목은 반드시 필요
    private String title; // 일정 제목 (예: "자료구조 과제")

    private String description; // 상세 설명 (예: "4장까지 요약")

    //시작 일자
    //마감 일자


    private LocalDateTime startTime; // 시작 시간
    private LocalDateTime endTime;   // 종료 시간

    private boolean completed; // 완료 여부 (true: 완료, false: 미완료)

    @Enumerated(EnumType.STRING)  // Enum 값을 문자열로 저장 (예: "STUDY")
    @Column(nullable = false)
    private Category category;

    @Min(1) // 최소값 1
    @Max(5) // 최대값 5
    @Column(nullable = false)
    private int priority;



    @Min(1)
    @Max(5)
    @Column(nullable = false)
    private int preference;


    @Column(nullable = false)
    private boolean isRepeated;

    //과제, 시험일 경우 페이지, 예상소요 시간, 단원 수
    //과제, 시험일 경우, 목차 넣기


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id") // FK 컬럼명 지정
    private User user;


}