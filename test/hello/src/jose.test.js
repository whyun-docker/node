// const jwt = require('jsonwebtoken');
const jose = require('jose');
// const keyConfig = require('./key');
// const token = 'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImJIWWxKMFlZX1A2UWxUNzV3alVPUXlnMzV4ZGoyUi1qN2VNOEV4VS1XZW8ifQ.eyJzdWIiOiI2MjQxODAzNjQ4MzI3OTdiZDkwZTY3MGIiLCJiaXJ0aGRhdGUiOm51bGwsImZhbWlseV9uYW1lIjpudWxsLCJnZW5kZXIiOiJVIiwiZ2l2ZW5fbmFtZSI6bnVsbCwibG9jYWxlIjpudWxsLCJtaWRkbGVfbmFtZSI6bnVsbCwibmFtZSI6IueZveS4gOaikyIsIm5pY2tuYW1lIjoi55m95LiA5qKTIiwicGljdHVyZSI6Imh0dHBzOi8vZ2l0ZWUuY29tL2Fzc2V0cy9ub19wb3J0cmFpdC5wbmciLCJwcmVmZXJyZWRfdXNlcm5hbWUiOm51bGwsInByb2ZpbGUiOiJodHRwczovL2dpdGVlLmNvbS95dW5ueXN1bm55IiwidXBkYXRlZF9hdCI6IjIwMjItMDYtMDdUMDY6NDM6MzEuMzI4WiIsIndlYnNpdGUiOiJodHRwOi8vYmxvZy53aHl1bi5jb20iLCJ6b25laW5mbyI6bnVsbCwibm9uY2UiOiIxODMxMjg5IiwiYXRfaGFzaCI6Il9hZnpfVEF1RG9NOVRnbmhWTWstdGciLCJzX2hhc2giOiJ3d0gzV3JVdm9IYklKeU1lWVR1OGx3IiwiYXVkIjoiNjI0M2U2MTQ1OGIzYzYwYWExZWMwZTdkIiwiZXhwIjoxNjU1NzkzODE1LCJpYXQiOjE2NTQ1ODQyMTUsImlzcyI6Imh0dHBzOi8vYXdzLWRlbW8teXVubnlzdW5ueS5hdXRoaW5nLmNuL29pZGMifQ.VhcFQBzHuYyU-88OZWMjj6nSn7S-tG6rZOLhu7Mamu8cLjHYfXKkxCbXyYMErl9X7HTy7cN7um-SX33YjDW3YEiO_f68wi2fdOMqu0wP1PXJuhPpsar95RAotPr70BX9KT3JKCHaLBJ3GElI0QI8hxQsB6ipR9umKhN6bDwWA2PCbakpPUbvvdh0fga_NypYNM7RBqBpi1vlYSOEPzblX7QSRCID2KOTt2gAb2-8xAjlWEQjBKYBkYVCsTlqkmFOCIKPNlPWhkJpP5zvU7wIGCf3L3pZKdAd0Y7lgd45BwfvInkHWJRYULs3H3SnKE-K3GKNzH0W3EeCTr74G554pA';

// const key = jose.JWK.asKey(keyConfig);
// const pubkey = key.toPEM();

// console.log('RSA Pubkey: ' + pubkey);
// const decoded = jwt.verify(token, pubkey, { algorithms: ['RS256'] });

// console.log('expired: ' + decoded.exp);
// console.log('current: ' + Date.parse(new Date()) / 1000);

const payload = {
    'urn:example:claim': 'foo'
};
  
const sign = jose.JWT.sign(payload, {
    e: 'AQAB',
    n:
      'o8iCY52uBPOCnBSRCr3YtlZ0UTuQQ4NCeVMzV7JBtH-7Vuv0hwGJTb_hG-BeYOPz8i6YG_o367smV2r2mnXbC1cz_tBfHD4hA5vnJ1eCpKRWX-l6fYuS0UMti-Bmg0Su2IZxXF9T1Cu-AOlpgXFC1LlPABL4E0haHO8OwQ6QyEfiUIs0byAdf5zeEHFHseVHLjsM2pzWOvh5e_xt9NOJY4vB6iLtD5EIak04i1ND_O0Lz0OYbuV0KjluxaxoiexJ8kGo9W1SNza_2TqUAR6hsPkeOwwh-oHnNwZg8OEnwXFmNg-bW4KiBrQEG4yUVdFGENW6vAQaRa2bJX7obn4xCw',
    d:
      'T2OGyHCLBH1gpvVVJObHIAMiGKoNkJwUYajRr0WJkcuEbGqtOa-l9Vj37cJBHSgBfDfXpWARMSOjPyZq6I4OIh4f5vjr0U3QROaSEkDZ46KA97a9mBNKlELC1hVsu15UfkIUuti-Uo7tZ5W8fXEAGwrD315Sf05H19SMy0mbJmjjHyLmBr1x-kD9Bbf3HBfSES0jLvf89BmvWmzkoUWGtgQ9mHa8A8KIirW16_t02dTbuvyXblNccMHRsKZSpkVCGbuMLxHlOq6YDo7IYaXKjTQM9QSAX_-NuUAg42EUY8enpEqhCa9LMIbLuWzj4aMf8PtDsKbP7mcJS-WEyD00KQ',
    p:
      '0Noq6uHlSWEHt0xb1Xzlh7KtoKVHqkpxPF_H5tyI56jZNV4YffVSgUsm79tp2l7f8G2T8TMpl7v16WJBUtTz1DPJLuTlp20uoNIYgIgs0qcAU2hKz4U8gdhhV2nwA6PfRbGpzknNI0QX6RFeP9YIJBufhNUruluO6NXzWIGGFf8',
    q:
      'yMG_r0NeQ86d3FJ_L3bviFpt-56kYYmAQZkUmUpBCsUPsb-OphtoiQeVfRQ_T7TX7mhImoR0_rQMwCwxLDfT_c6K3g05qjAtSCh7MHz_Jv3MYz6ZyodCNPyrIOKX8xJP_n5um0WnDAWuqakTt8UO2gZ2twCe8Z8qmgOsmOm83PU',
    dp:
      'TGMfQ11v4VDN46rYA9N0mBcwDgullJE5rV1S3gtXP3OwTiamSpuJm6SDD0NvCeGdgnBxpcySr96daMj5H3Sn4bs3ICG0JXJ3lXaCY7BqxHk0U01X32LZ6Jvdrn0evhYXuYPrmXnAv99N537ku_Bqddpsk8bsAXMvZ9Wo9XwaML0',
    dq:
      'qEPMeAfNMKQzKAF1XMEhT3YMDQQQ3zeyakj2PO1BytcUqnTWCV-bpI7YuveHgTUgb1C02d3_eaRLs57WsCsy4d6GAkuvc3fh3EMhzahW68V51A0aNehck7Dbdjq2BSPqLHKoHjipJKh2lvmB71uZcSBNzGEW14oC2QgPWDNA-yk',
    qi:
      'Sr1NS31enngj4aXaGW0MIYKo6DmKWH2xmjQmNDn9EU839O0tZ6goo6H4PgG3VYgS5gHMX2gLzpTwRHMxKXnhUr4d_ZCbysNqP3WzJZbjdWfYnmn7pgbuoh6a0YW_doGhRhGpSQCjB1AvGupX4CmR_ty-YbLBIqdzCf60gnleq8A',
    kty: 'RSA',
}, {
    audience: ['urn:example:client'],
    issuer: 'https://op.example.com',
    expiresIn: '2 hours',
    header: {
        typ: 'JWT'
    }
});
console.log('sign', sign);
exports.sign = sign;
