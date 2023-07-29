import { ValidationOptions, registerDecorator } from 'class-validator';

export const IsUserId = (validationOptions?: ValidationOptions) => {
	return (object: Object, propertyName: string) => {
		registerDecorator({
			name: 'isUserId',
			target: object.constructor,
			propertyName: propertyName,
			options: validationOptions,
			validator: {
				validate(value: any) {
					return typeof value === 'string' && /^user_[a-zA-Z0-9]+$/.test(value);
				},
			},
		});
	};
};
