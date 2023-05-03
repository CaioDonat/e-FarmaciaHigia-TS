interface IMailTo {
    name: string;
    email: string;
}

interface IMailMessage {
    subject: string;
    body: string;
    attachments?: string[]
}

class EmailService {
    sendEmail(to: IMailTo, message: IMailMessage){
        console.log('sendEmail')
    }
}

export default EmailService;