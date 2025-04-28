package capstone.backend.time.controller;


import capstone.backend.time.domain.PreferredTime;
import capstone.backend.time.domain.TimePurpose;
import capstone.backend.time.domain.TimeSlot;
import capstone.backend.time.service.PreferredTimeService;
import capstone.backend.user.User;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/preferred-times")
@RequiredArgsConstructor
public class PreferredTimeController {

    private final PreferredTimeService preferredTimeService;

    @PostMapping
    public PreferredTime createPreferredTime(@RequestParam Long userId, @RequestParam TimeSlot timeSlot, @RequestParam TimePurpose purpose) {

        User user = userService.findById(userId);
        return preferredTimeService.savePreferredTime(user, timeSlot, purpose);
    }

    @GetMapping
    public List<PreferredTime> getAllPreferredTimes() {
        return preferredTimeService.findAll();
    }
}
