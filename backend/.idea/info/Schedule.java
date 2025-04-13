import java.time.LocalDate;

public class Schedule {
    Long scheduleId; // 일정 ID (자동 증가 기본 키)

    User user; // 일정 소유 사용자

    String title; // 일정 제목
    Category category; // 일정 유형(enum)
    Integer priority, estimatedDuration; // 중요도(1~5), 예상 소요 시간(분)
    LocalDate start, end; // 시작일, 마감일
    Boolean isRepeating; // 반복 일정 여부
    String notes; // 메모
}
