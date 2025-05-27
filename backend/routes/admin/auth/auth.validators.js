const { z } = require('zod');

const adminSignupSchema = z.object({
  fullName: z.string().min(2, "Name too short"),
  email: z.string().email("Invalid email"),
  password: z.string().min(8, "Minimum 8 characters"),
  contactNumber: z.string().regex(/^\d{10}$/, "Must be 10 digits"),
  department: z.enum(['Water Supply', 'Road Maintenance'])
});


module.exports = {
  adminSignupSchema,
};