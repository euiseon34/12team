package capstone.backend.timeblock.controller;


import capstone.backend.timeblock.domain.TimeBlock;
import capstone.backend.timeblock.service.TimeBlockService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/timeblocks")
@RequiredArgsConstructor
public class TimeBlockController {
gi
    private final TimeBlockService timeBlockService;

    @PostMapping
    public TimeBlock createTimeBlock(@RequestBody TimeBlock timeBlock) {
        return timeBlockService.saveTimeBlock(timeBlock);
    }

    @PostMapping("/bulk")
    public List<TimeBlock> createTimeBlocks(@RequestBody List<TimeBlock> timeBlocks) {
        return timeBlockService.saveTimeBlocks(timeBlocks);
    }

    @GetMapping("/{userId}")
    public List<TimeBlock> getTimeBlocksByUser(@PathVariable Long userId) {
        return timeBlockService.getTimeBlocksByUser(userId);
    }

    @GetMapping
    public List<TimeBlock> getAllTimeBlocks() {
        return timeBlockService.getAllTimeBlocks();
    }
}
