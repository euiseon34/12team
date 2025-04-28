package capstone.backend;

import capstone.backend.user.User;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TimeBlock {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDateTime startTime; // 블로킹 시작 시간
    private LocalDateTime endTime;   // 블로킹 종료 시간

    private String category; // 카테고리 (예: "공부", "휴식", "식사" 등)

    /**
     * 해당 블록은 하나의 사용자(User)에 속함
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;


}