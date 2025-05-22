using System;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Payments.data
{
    public static class SecurityHelper
    {
        private const int SaltSize = 16;
        private const int KeySize = 32;
        private const int Iterations = 10000;

        public static (string Hash, string Salt) CreatePasswordHash(string password)
        {
            using (var rng = RandomNumberGenerator.Create())
            {
                var saltBytes = new byte[SaltSize];
                rng.GetBytes(saltBytes);

                using (var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, Iterations, HashAlgorithmName.SHA256))
                {
                    var hashBytes = pbkdf2.GetBytes(KeySize);

                    return (Convert.ToBase64String(hashBytes), Convert.ToBase64String(saltBytes));
                }
            }
        }

        public static bool VerifyPassword(string password, string storedHash, string storedSalt)
        {
            var saltBytes = Convert.FromBase64String(storedSalt);
            var storedHashBytes = Convert.FromBase64String(storedHash);

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, Iterations, HashAlgorithmName.SHA256))
            {
                var computedHash = pbkdf2.GetBytes(KeySize);

                return storedHashBytes.SequenceEqual(computedHash);
            }
        }
    }

}
