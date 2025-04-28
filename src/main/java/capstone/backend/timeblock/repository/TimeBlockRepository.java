package capstone.backend.timeblock.repository;

import capstone.backend.timeblock.domain.TimeBlock;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TimeBlockRepository extends JpaRepository<TimeBlock, Long> {

    List<TimeBlock> findByUserId(Long userId);
}