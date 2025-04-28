package capstone.backend.time.domain;

import capstone.backend.user.User;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
public class PreferredTime {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    @Enumerated(EnumType.STRING)
    private TimeSlot timeSlot;

    @Enumerated(EnumType.STRING)
    private TimePurpose purpose;

    public PreferredTime(User user, TimeSlot timeSlot, TimePurpose purpose) {
        this.user = user;
        this.timeSlot = timeSlot;
        this.purpose = purpose;
    }

    public int getStartHour() {
        return timeSlot.getStartHour();
    }

    public int getEndHour() {
        return timeSlot.getEndHour();
    }







}
