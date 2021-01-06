package it.polimi.se2.clupapplication.config;

import it.polimi.se2.clupapplication.security.JwtAuthenticationFilter;
import it.polimi.se2.clupapplication.security.TokenProvider;
import it.polimi.se2.clupapplication.security.UnauthorizedEntryPoint;
import it.polimi.se2.clupapplication.security.services.socialAuth.FacebookConnectionSignup;
import it.polimi.se2.clupapplication.security.services.socialAuth.FacebookSignInAdapter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.social.connect.ConnectionFactoryLocator;
import org.springframework.social.connect.UsersConnectionRepository;
import org.springframework.social.connect.mem.InMemoryUsersConnectionRepository;
import org.springframework.social.connect.support.ConnectionFactoryRegistry;
import org.springframework.social.connect.web.ProviderSignInController;
import org.springframework.social.facebook.connect.FacebookConnectionFactory;

import javax.annotation.Resource;

/**
 * This class is the configuration one of the Web Security Backend offered by Spring framework.
 * @see org.springframework.security.config.annotation.SecurityConfigurer
 */
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Value("${spring.social.facebook.appSecret}")
    String appSecret;

    @Value("${spring.social.facebook.appId}")
    String appId;

    @Autowired
    private FacebookConnectionSignup facebookConnectionSignup;

    @Resource(name = "userService")
    private UserDetailsService userDetailsService;

    @Autowired
    private UnauthorizedEntryPoint unauthorizedEntryPoint;

    @Autowired
    private TokenProvider jwtTokenUtil;

    @Override
    public void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(encoder());
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.cors().and().csrf().disable()
                .authorizeRequests()
                .antMatchers("/auth/login", "/auth/signup", "/signin/**", "/signup/**", "/login*").permitAll()
                .anyRequest().authenticated()
                .and()
                .formLogin().loginPage("/login").permitAll()
                .and()
                .exceptionHandling().authenticationEntryPoint(unauthorizedEntryPoint).and()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);

        http.addFilterBefore(authenticationTokenFilterBean(), UsernamePasswordAuthenticationFilter.class);
    }

    @Bean
    @Primary
    public ProviderSignInController providerSignInController() {
        ConnectionFactoryLocator connectionFactoryLocator = connectionFactoryLocator();
        UsersConnectionRepository usersConnectionRepository = getUsersConnectionRepository(connectionFactoryLocator);
        ((InMemoryUsersConnectionRepository) usersConnectionRepository).setConnectionSignUp(facebookConnectionSignup);
        ProviderSignInController signInController = new ProviderSignInController(connectionFactoryLocator, usersConnectionRepository, new FacebookSignInAdapter(jwtTokenUtil));
        return signInController;
    }

    public UsersConnectionRepository getUsersConnectionRepository(ConnectionFactoryLocator connectionFactoryLocator) {
        return new InMemoryUsersConnectionRepository(connectionFactoryLocator);
    }

    public ConnectionFactoryLocator connectionFactoryLocator() {
        ConnectionFactoryRegistry registry = new ConnectionFactoryRegistry();
        registry.addConnectionFactory(new FacebookConnectionFactory(appId, appSecret));
        return registry;
    }

    @Bean
    public BCryptPasswordEncoder encoder(){
        return new BCryptPasswordEncoder();
    }

    @Override
    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Bean
    public JwtAuthenticationFilter authenticationTokenFilterBean() throws Exception {
        return new JwtAuthenticationFilter();
    }

}