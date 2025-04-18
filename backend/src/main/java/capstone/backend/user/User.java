package capstone.backend.user;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id // 기본 키(primary key) 지정
    @GeneratedValue(strategy = GenerationType.IDENTITY) // auto-increment 전략
    private Long id;

    @Column(nullable = false, unique = true) // 중복 불가, 필수값
    private String username; // 사용자 이름 또는 ID

    private String password; // 비밀번호 (※ 추후 암호화 필요)

    private String email; // 이메일 주소

    @Enumerated(EnumType.STRING)
    private PreferredTime preferredTime; // 사용자가 선호하는 시간대 (
}
