package it.polimi.se2.clupapplication.security.services.socialAuth;

import it.polimi.se2.clupapplication.security.TokenProvider;
import it.polimi.se2.clupapplication.services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.social.connect.Connection;
import org.springframework.social.connect.web.SignInAdapter;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.context.request.ServletWebRequest;

import javax.servlet.http.Cookie;
import java.util.Arrays;

@Service
public class FacebookSignInAdapter implements SignInAdapter {
    @Autowired
    private AuthenticationManager authenticationManager;

    private TokenProvider jwtTokenUtil;

    @Autowired
    private UserService userService;

    public FacebookSignInAdapter(TokenProvider jwtTokenUtil) {
        this.jwtTokenUtil = jwtTokenUtil;
    }

    @Override
    public String signIn(String localUserId, Connection<?> connection, NativeWebRequest request) {
        System.out.println(" ====== Sign In adapter");
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(localUserId, null, Arrays.asList(new SimpleGrantedAuthority("ROLE_USER")));
        /*Authentication authentication = authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(
                connection.getKey().getProviderUserId(), null
        ));*/
        SecurityContextHolder.getContext().setAuthentication(authenticationToken);
        String token = jwtTokenUtil.generateToken(authenticationToken);
        ((ServletWebRequest) request).getResponse().addCookie(getSocialAuthenticationCookie(token));
        return null;
    }

    private Cookie getSocialAuthenticationCookie(String token) {
        Cookie socialAuthCookie = new Cookie("social-authentication", token);
        socialAuthCookie.setPath("/");
        socialAuthCookie.setMaxAge(10);
        return socialAuthCookie;
    }
}
