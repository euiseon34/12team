public class Task {
    // 일정에 속하는 세부 작업(Task)을 저장하는 클래스

    Long taskId; // 작업 ID (기본 키)

    Schedule schedule; // 소속된 일정

    String title, status, memo; // 작업 제목, 상태(예: 완료/진행중), 메모
    Integer duration, sequenceOrder; // 소요 시간, 작업 순서
}
