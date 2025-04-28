package capstone.backend.timeblock.service;

import capstone.backend.timeblock.domain.TimeBlock;
import capstone.backend.timeblock.repository.TimeBlockRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TimeBlockService {

    private final TimeBlockRepository timeBlockRepository;

    public TimeBlock saveTimeBlock(TimeBlock timeBlock) {
        return timeBlockRepository.save(timeBlock);
    }

    public List<TimeBlock> saveTimeBlocks(List<TimeBlock> timeBlocks) {
        return timeBlockRepository.saveAll(timeBlocks);
    }

    public List<TimeBlock> getTimeBlocksByUser(Long userId) {
        return timeBlockRepository.findByUserId(userId);
    }

    public List<TimeBlock> getAllTimeBlocks() {
        return timeBlockRepository.findAll();
    }
}
