package capstone.backend.time.service;


import capstone.backend.time.domain.PreferredTime;
import capstone.backend.time.domain.TimePurpose;
import capstone.backend.time.domain.TimeSlot;
import capstone.backend.time.repository.PreferredTimeRepository;
import capstone.backend.user.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PreferredTimeService {

    private final PreferredTimeRepository preferredTimeRepository;

    //PreferredTime 저장
    public PreferredTime savePreferredTime(User user, TimeSlot slot, TimePurpose purpose){
        PreferredTime preferredTime = new PreferredTime(user, slot, purpose);
        return preferredTimeRepository.save(preferredTime);
    }

    //전체 조회
    public List<PreferredTime> findAll(){
        return preferredTimeRepository.findAll();
    }
}
