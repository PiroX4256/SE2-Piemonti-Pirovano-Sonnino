package it.polimi.se2.clupapplication.config;

import it.polimi.se2.clupapplication.entities.Role;
import it.polimi.se2.clupapplication.entities.WeekDay;
import it.polimi.se2.clupapplication.repositories.RoleRepository;
import it.polimi.se2.clupapplication.repositories.WeekDayRepository;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.HashSet;
import java.util.Set;

@Component
public class DBPopulation {
    private static Log LOG = LogFactory.getLog("ContextLoaderListener");

    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private WeekDayRepository weekDayRepository;

    @PostConstruct
    public void dbInitializer() {

        if(roleRepository.findAll().size()==0) {
            LOG.info("Role table empty ... adding new data");
            Role manager = new Role();
            manager.setName("MANAGER");
            manager.setDescription("Manager Role");
            roleRepository.save(manager);
            Role attendant = new Role();
            attendant.setName("ATTENDANT");
            attendant.setDescription("Attendant Role");
            roleRepository.save(attendant);
            Role user = new Role();
            user.setName("USER");
            user.setDescription("Customer Role");
            roleRepository.save(user);
        }
        if(weekDayRepository.findAll().size() == 0) {
            LOG.info("Days table empty ... adding new data");
            Set<WeekDay> weekDaySet = new HashSet<>();
            weekDaySet.add(new WeekDay(1, "Sunday"));
            weekDaySet.add(new WeekDay(2, "Monday"));
            weekDaySet.add(new WeekDay(3, "Tuesday"));
            weekDaySet.add(new WeekDay(4, "Wednesday"));
            weekDaySet.add(new WeekDay(5, "Thursday"));
            weekDaySet.add(new WeekDay(6, "Friday"));
            weekDaySet.add(new WeekDay(7, "Saturday"));
            weekDayRepository.saveAll(weekDaySet);
        }
        LOG.info("DB loading successful");
    }
}
