const { z } = require('zod');

const signupschema = z.object({
  username: z.string()
    .min(2, "At least 2 characters needed")
    .max(10, "Username is too long")
    .refine((val) => /[A-Za-z]/.test(val), "Username should contain at least one alphabet character."),
  
  email: z.string().email("Invalid email address"),

  password: z.string()
    .min(8, "Password should contain at least 8 characters")
    .refine((val) => /[!@#$%^&*(){}+-.<>]/.test(val), "Password should contain at least one special character")
    .refine((val) => /[A-Z]/.test(val), "Password should contain at least one uppercase character."),

  contactnumber: z.string().regex(/^\d{10}$/, {
    message: "Contact number must be exactly 10 digits",
  }),
});

module.exports = {
  signupschema,
};