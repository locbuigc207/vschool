library endpoint;

/// /api/app/auth/login
const login = '/api/app/auth/login';

/// /api/app/auth/log-out
const logout = '/api/app/auth/log-out';

/// /api/app/auth/refreshToken
const refreshToken = '/api/app/auth/refreshToken';

/// /api/reset-password
const resetPass = '/api/reset-password';

/// /api/change_password
const changePass = '/api/change_password';

/// /api/get-parent-by-userid
const currentUser = '/api/get-parent-by-userid';

/// /api/get-student-by-parent-phoneNum
const getAllChild = '/api/get-student-by-parent-phoneNum';

/// /api/get-student
const getChildById = '/api/get-student';

/// /api/get-notification-by-receiverId
const getAllNotification = '/api/get-notification-by-receiverId';

/// /api/get-student-invoice-by-studentid
const getInvoiceByChild = '/api/app/student/get-list-invoices-by-student';

/// /api/bank-info
const getAllBankInfo = '/api/app/bank-info';

/// /api/generateQRPayment
const genQr = '/api/app/student/generate-qr-payment';

/// /api/get-info-student
const getSchoolInfo = '/api/get-info-student';

/// /api/save-admissions
const submitAdmissions = '/api/save-admissions';

/// /api/update-notification
const readNotification = '/api/update-notification';

/// /api/getReportByStudentId
const getReportCard = '/api/getReportByStudentId';

/// /api/saveReportCard
const saveReportCard = '/api/saveReportCard';

/// /api/getFoodMenu
const getFoodMenu = '/api/getFoodMenu';

/// /api/get-heath-info-by-studentId
const getHeathInfo = '/api/get-heath-info-by-studentId';

/// /api/get-all-banner
const getBannerContent = '/api/get-all-banner';

/// /api/get-score-student
const getScore = '/api/get-score-student';

/// /api/get-schedule-by-class-id
const getSchedule = '/api/get-schedule-by-class-id';

/// /api/update-student-v2
const updateInfoStudent = '/api/update-student-v2';

/// /api/get-student-invoice-by-student-code
const getInvoiceByStudentCode = '/api/get-student-invoice-by-student-code';

/// /api/get-student-by-code
const getStudentByCode = '/api/get-student-by-code';

/// /api/app/notification/register-device
const registerDevice = '/api/app/notification/register-device';

/// /api/app/student/get-payment-setting
const getPaymentSetting = '/api/app/student/get-payment-setting';
