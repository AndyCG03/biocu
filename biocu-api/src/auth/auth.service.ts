/* eslint-disable @typescript-eslint/no-unused-vars */
/* eslint-disable @typescript-eslint/no-unsafe-member-access */
/* eslint-disable @typescript-eslint/no-unsafe-call */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import {
  ConflictException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { UsersService } from 'src/users/users.service';
import { RegisterUserDTO } from './dto/register.dto';
import * as bcrypt from 'bcrypt';
import { LoginUserDto } from 'src/users/dto/login-user.dto';
import { JwtService } from '@nestjs/jwt';
import { UserActiveInterface } from 'src/common/interfaces/active-user.interface';
@Injectable()
export class AuthService {
  private readonly SALT_ROUNDS = 10;

  constructor(
    private readonly usersService: UsersService,
    private readonly jwtservice: JwtService,
  ) {}

  async register(registerUserDTO: RegisterUserDTO) {
    const user = await this.usersService.findByEmail(registerUserDTO.email);

    if (user) {
      throw new ConflictException(
        'El usuario ya esta registrado , cambie su email',
      );
    }

    // Hash de la contraseña
    const hashedPassword = await bcrypt.hash(
      registerUserDTO.password_hash,
      this.SALT_ROUNDS,
    );

    console.log(hashedPassword);
    registerUserDTO.password_hash = hashedPassword;
    console.log(registerUserDTO);

    return await this.usersService.create(registerUserDTO);
  }

  async login({ email, password }: LoginUserDto) {
    const user = await this.usersService.findOneByEmailWithPassword(email);
    if (!user) {
      throw new UnauthorizedException('email es incorrecto');
    }

    const isPasswordValid = await bcrypt.compare(password, user.password_hash);

    if (!isPasswordValid) {
      throw new UnauthorizedException('contraseña es incorrecta');
    }

    const payload = { sub: user.id, email: user.email, role: user.role };
    const token = await this.jwtservice.signAsync(payload);

    return { token };
  }

  async profile(user: UserActiveInterface) {
    return await this.usersService.findByEmail(user.email);
  }
}
