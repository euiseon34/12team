package capstone.backend.time.domain;

public enum TimeSlot {

    MORNING(6, 12),
    AFTERNOON(12, 18),
    EVENING(18, 22),
    DAWN(22, 6);

    private final int startHour;
    private final int endHour;

    TimeSlot(int startHour, int endHour) {
        this.startHour = startHour;
        this.endHour = endHour;
    }

    public int getStartHour() {
        return startHour;
    }

    public int getEndHour() {
        return endHour;
    }

    public static TimeSlot fromHour(int hour) {
        if (hour >= 6 && hour < 12) return MORNING;
        if (hour >= 12 && hour < 18) return AFTERNOON;
        if (hour >= 18 && hour < 22) return EVENING;
        return DAWN;
    }
}
